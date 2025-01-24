cmake_minimum_required(VERSION 2.6)

# set project name from current directory
get_filename_component(BASENAME ${CMAKE_SOURCE_DIR} NAME)
project(${BASENAME})

set(CMAKE_C_FLAGS "-Wall")
set(CMAKE_CXX_FLAGS "-std=c++11 -Wall -O3 -DNO_STD_LIB")


# define executable to build
include_directories("inc")
aux_source_directory(src SRC_FILES)
add_executable(${PROJECT_NAME} ${SRC_FILES})

if (COVERAGE)
	set(COVERAGE_FLAGS "-g -O0 -fprofile-arcs -ftest-coverage")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COVERAGE_FLAGS}")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COVERAGE_FLAGS}")
	target_link_libraries(${PROJECT_NAME} gcov)
endif()

# libv4l2cpp
include_directories(../v4l2cpp/inc)
find_library(V4L2CPP_LIBRARY libv4l2cpp.a PATHS "." NO_CMAKE_FIND_ROOT_PATH)
if (NOT V4L2CPP_LIBRARY)
        message(STATUS "Installing libv4l2cpp")
        EXEC_PROGRAM("cd ../v4l2cpp && cmake . && make VERBOSE=1 -j4 && cp libv4l2cpp.a ${CMAKE_SOURCE_DIR} && make clean")
        find_library(V4L2CPP_LIBRARY libv4l2cpp.a PATHS "." NO_CMAKE_FIND_ROOT_PATH)
        message(STATUS "libv4l2cpp built in V4L2CPP_LIBRARY=${V4L2CPP_LIBRARY}")
endif (NOT V4L2CPP_LIBRARY)
target_link_libraries(${PROJECT_NAME} PUBLIC ${V4L2CPP_LIBRARY})

#pthread
find_package (Threads)
target_link_libraries (${PROJECT_NAME} PUBLIC ${CMAKE_THREAD_LIBS_INIT})

#ALSA
#target_link_libraries (${PROJECT_NAME} PUBLIC ${ALSA_LIBRARY})


#find_path(LIBLIVE555_INCLUDE_DIR liveMedia/liveMedia.hh)
#include_directories(../live555/liveMedia/include)
#include_directories(/src/tmp/Xiaomi-Dafang-Software/live/liveMedia/include)


include_directories(../v4l2rtspserver-tools/)
add_library(sharedmem ../v4l2rtspserver-tools/sharedmem.cpp)
target_link_libraries(${PROJECT_NAME} sharedmem)

include_directories("filter")
add_library(filter filter/g711super.c  filter/noise_remover.c  filter/wave.c filter/mylog.c)
target_link_libraries(${PROJECT_NAME} filter)

#include_directories(../live/liveMedia/)
foreach (LIBLIVE555_module groupsock liveMedia UsageEnvironment BasicUsageEnvironment)
	include_directories(../Modules/live/live555/${LIBLIVE555_module}/include)

endforeach (LIBLIVE555_module)

include_directories(../_install/include)
include_directories(../Modules/freetype2/freetype2/include)

set(LIBLIVE555_LIBRARIES "")
foreach (LIBLIVE555_module groupsock liveMedia UsageEnvironment BasicUsageEnvironment)
	find_library( ${LIBLIVE555_module}_LIBRARY ${LIBLIVE555_module} )
	if ( ${LIBLIVE555_module}_LIBRARY )
		set(LIBLIVE555_LIBRARIES ${LIBLIVE555_LIBRARIES} ${${LIBLIVE555_module}_LIBRARY})
	endif ( ${LIBLIVE555_module}_LIBRARY )
endforeach (LIBLIVE555_module)


# Separate treatments of dynamic and static libs
set(DEPENDLIBS ${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libliveMedia.so ;
                ${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libgroupsock.so ;
                ${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libUsageEnvironment.so ;
                ${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libBasicUsageEnvironment.so ;
                ${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libalog.so ;
                ${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libimp.so ;
                ${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libsysutils.so;
)

foreach (LIB ${DEPENDLIBS})
    target_link_libraries(${PROJECT_NAME} PRIVATE ${LIB})
#    install(FILES ${LIB} DESTINATION libs NAMELINK_ONLY)
endforeach (LIB)

target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/libv4l2cpp.a")
target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/libfilter.a")
target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libfreetype.a")
target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libmp3lame.a")
target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libopus.a")
target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libtls.a")
target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libcrypto.a")
target_link_libraries(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../_install/lib/libssl.a")



# Install
install (TARGETS ${PROJECT_NAME} DESTINATION bin)



