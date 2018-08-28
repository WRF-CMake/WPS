# Copyright 2018 M. Riechert and D. Meyer. Licensed under the MIT License.

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)

add_definitions(-D_UNGRIB)

if (ENABLE_GRIB2_PNG)
    list(APPEND GRIB2_COMPRESSION_LIBRARIES
        ${PNG_LIBRARIES}
        ${ZLIB_LIBRARIES} # needed by libpng apparently
    )
    include_directories(
        ${PNG_INCLUDE_DIRS}
        ${ZLIB_INCLUDE_DIRS}
    )
    add_definitions(-DUSE_PNG)
endif()

if (ENABLE_GRIB2_JPEG2000)
    list(APPEND GRIB2_COMPRESSION_LIBRARIES
        ${JASPER_LIBRARIES}
    )
    include_directories(
        ${JASPER_INCLUDE_DIRS}
    )
    add_definitions(-DUSE_JPEG2000)
endif()

add_subdirectory(ngl)

add_definitions(-DBIT32)

add_library(pgu STATIC
    "${GEOGRID_SRC}/module_debug.F"
    "${GEOGRID_SRC}/misc_definitions_module.F"
    build_hdate.F
    geth_newdate.F
    geth_idts.F
    swap.F
    table.F
    parse_table.F
    gbytesys.F
    module_stringutil.F
    gribcode.F
    read_namelist.F
    gridinfo.F
    new_storage.F
    cio.c
)

set_property(TARGET pgu PROPERTY Fortran_FORMAT FREE)

target_include_directories(pgu
	INTERFACE ${CMAKE_Fortran_MODULE_DIRECTORY}
)

# Makefile references debug_cio.c which is a symlink to cio.c in geogrid.
# Although it is possible to use ${GEOGRID_SRC}/cio.c directly we emulate
# the Makefile behaviour so that, if needed, -save-temps doesn't override
# the intermediate .i file of the other cio.c in this folder.
configure_file(${GEOGRID_SRC}/cio.c debug_cio.c COPYONLY)

add_executable(g1print
    ${GEOGRID_SRC}/module_debug.F
    ${CMAKE_CURRENT_BINARY_DIR}/debug_cio.c
    g1print.F
)

set_property(TARGET g1print PROPERTY Fortran_FORMAT FREE)

target_link_libraries(g1print
    pgu
)

add_executable(g2print
    filelist.F
    gridinfo.F
    g2print.F
)

set_property(TARGET g2print PROPERTY Fortran_FORMAT FREE)

target_link_libraries(g2print
    ${GRIB2_COMPRESSION_LIBRARIES}
    pgu
    w3
    g2
)

add_executable(ungrib
    "${GEOGRID_SRC}/misc_definitions_module.F"
    "${GEOGRID_SRC}/module_debug.F"
    debug_cio.c
    module_stringutil.F
    table.F
    module_datarray.F
    gridinfo.F
    new_storage.F
    filelist.F
    ungrib.F
    output.F
    rrpr.F
    rd_grib1.F
    file_delete.F
    datint.F
    rd_grib2.F
)

set_property(TARGET ungrib PROPERTY Fortran_FORMAT FREE)
set_property(SOURCE rd_grib2.F PROPERTY Fortran_FORMAT FIXED)

target_link_libraries(ungrib
    ${GRIB2_COMPRESSION_LIBRARIES}
    pgu
    w3
    g2
)

install( TARGETS g1print g2print ungrib
    RUNTIME DESTINATION .
)