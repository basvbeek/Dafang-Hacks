/*
 * sample-audio.c
 *
 * Copyright (C) 2014 Ingenic Semiconductor Co.,Ltd
 */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>

#include <imp/imp_audio.h>
#include <imp/imp_log.h>

#define TAG "Sample-Audio"

#define AEC_SAMPLE_RATE 8000
#define AEC_SAMPLE_TIME 10

#define IMP_AUDIO_BUF_SIZE (5 * (AEC_SAMPLE_RATE * sizeof(short) * AEC_SAMPLE_TIME / 1000))

#define IMP_LOG IMP_LOG_PRINT

int chnVol = 50;



static void *IMP_Audio_Play_ALGO_AO_Thread(void *argv)
{
	unsigned char *buf = NULL;
	int size = 0;
	int ret = -1;

	if(argv == NULL) {
		IMP_LOG_ERR(TAG, "[ERROR] %s: Please input the play file name.\n", __func__);
		return NULL;
	}

	buf = (unsigned char *)malloc(IMP_AUDIO_BUF_SIZE);
	if(buf == NULL) {
		IMP_LOG_ERR(TAG, "[ERROR] %s: malloc audio buf error\n", __func__);
		return NULL;
	}

	FILE *play_file = fopen(argv, "rb");
	if(play_file == NULL) {
		IMP_LOG_ERR(TAG, "[ERROR] %s: fopen %s failed\n", __func__, argv);
		return NULL;
	}

	/* Step 1: set public attribute of AO device. */
	int devID = 0;
	IMPAudioIOAttr attr;
	attr.samplerate = AUDIO_SAMPLE_RATE_8000;
	attr.bitwidth = AUDIO_BIT_WIDTH_16;
	attr.soundmode = AUDIO_SOUND_MODE_MONO;
	attr.frmNum = 20;
	attr.numPerFrm = 400;
	attr.chnCnt = 1;
	ret = IMP_AO_SetPubAttr(devID, &attr);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "set ao %d attr err: %d\n", devID, ret);
		return NULL;
	}

	memset(&attr, 0x0, sizeof(attr));
	ret = IMP_AO_GetPubAttr(devID, &attr);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "get ao %d attr err: %d\n", devID, ret);
		return NULL;
	}

	IMP_LOG_INFO(TAG, "Audio Out GetPubAttr samplerate:%d\n", attr.samplerate);
	IMP_LOG_INFO(TAG, "Audio Out GetPubAttr   bitwidth:%d\n", attr.bitwidth);
	IMP_LOG_INFO(TAG, "Audio Out GetPubAttr  soundmode:%d\n", attr.soundmode);
	IMP_LOG_INFO(TAG, "Audio Out GetPubAttr     frmNum:%d\n", attr.frmNum);
	IMP_LOG_INFO(TAG, "Audio Out GetPubAttr  numPerFrm:%d\n", attr.numPerFrm);
	IMP_LOG_INFO(TAG, "Audio Out GetPubAttr     chnCnt:%d\n", attr.chnCnt);

	/* Step 2: enable AO device. */
	ret = IMP_AO_Enable(devID);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "enable ao %d err\n", devID);
		return NULL;
	}

	/* Step 3: enable AI channel. */
	int chnID = 0;
	ret = IMP_AO_EnableChn(devID, chnID);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "Audio play enable channel failed\n");
		return NULL;
	}

	/* Step 4: Set audio channel volume. */
	ret = IMP_AO_SetVol(devID, chnID, chnVol);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "Audio Play set volume failed\n");
		return NULL;
	}

	ret = IMP_AO_GetVol(devID, chnID, &chnVol);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "Audio Play get volume failed\n");
		return NULL;
	}

	IMP_LOG_INFO(TAG, "Audio Out GetVol    vol:%d\n", chnVol);

	ret = IMP_AO_EnableHpf(&attr);
	if(ret != 0) {
		printf("enable audio hpf error.\n");
		IMP_LOG_INFO(TAG, "enable audio hpf error.\n");
		return NULL;
	}

	while(1) {
		size = fread(buf, 1, IMP_AUDIO_BUF_SIZE, play_file);
		/* Step 5: send frame data. */
		if (size > 0) {
			IMPAudioFrame frm;
			frm.virAddr = (uint32_t *)buf;
			frm.len = size;
			ret = IMP_AO_SendFrame(devID, chnID, &frm, BLOCK);
			if (ret != 0) {
				IMP_LOG_ERR(TAG, "send Frame Data error\n");
				return NULL;
			}
		} else {
			IMPAudioOChnState play_status;
			ret = IMP_AO_QueryChnStat(devID, chnID, &play_status);
			if (ret != 0) {
				IMP_LOG_ERR(TAG, "IMP_AO_QueryChnStat error\n");
				return NULL;
			}
			//IMP_LOG_INFO(TAG, "Play: TotalNum %d, FreeNum %d, BusyNum %d\n",
			//             play_status.chnTotalNum, play_status.chnFreeNum, play_status.chnBusyNum);

			// No need to consume CPU, but we can't continue the program
			// or else the audio channel is disabled.
			// There are buffers filled that are still playing.
			sleep(1);

			// Every frame has been played
			if (play_status.chnBusyNum == 0)
				break;
		}
	}

	/* Step 6: disable the audio channel. */
	ret = IMP_AO_DisableChn(devID, chnID);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "Audio channel disable error\n");
		return NULL;
	}

	/* Step 7: disable the audio devices. */
	ret = IMP_AO_Disable(devID);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "Audio device disable error\n");
		return NULL;
	}

	fclose(play_file);
	free(buf);
	pthread_exit(0);
}

void usage() {
	IMP_LOG_ERR(TAG, "Usage: audioplay file volume\r\n");
	exit(1);
}

int  main(int argc, char *argv[])
{

	if (argc <= 1)
		usage();

	char* file = argv[1];
	int ret;

    if (argc > 2 && argv[2] != NULL)
    {
        chnVol = atoi(argv[2]);
        printf("Volume is %d\n", chnVol);
    }
	pthread_t play_thread_id;

	ret = pthread_create(&play_thread_id, NULL, IMP_Audio_Play_ALGO_AO_Thread, file);
	if(ret != 0) {
		IMP_LOG_ERR(TAG, "[ERROR] %s: pthread_create Audio Play failed\n", __func__);
		return -1;
	}
	pthread_join(play_thread_id, NULL);



	return 0;
}
