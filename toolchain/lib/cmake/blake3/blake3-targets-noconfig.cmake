#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "BLAKE3::blake3" for configuration ""
set_property(TARGET BLAKE3::blake3 APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(BLAKE3::blake3 PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libblake3.so.1.5.4"
  IMPORTED_SONAME_NOCONFIG "libblake3.so.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS BLAKE3::blake3 )
list(APPEND _IMPORT_CHECK_FILES_FOR_BLAKE3::blake3 "${_IMPORT_PREFIX}/lib/libblake3.so.1.5.4" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
