vcpkg_minimum_required(VERSION 2022-10-12) # for ${VERSION}
vcpkg_download_distfile(ARCHIVE
    URLS "https://download.osgeo.org/geos/geos-${VERSION}.tar.bz2"
    FILENAME "geos-${VERSION}.tar.bz2"
    SHA512 b5df5b773bef595335e1be6c6d3325f932f1577e2a4b8bdfa8cf26f09c7d41ed5e0695ca15826d1f95bc4a45b777839c2be8a96a8af5415c8bcf58cc804eb1ec
)
vcpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    SOURCE_BASE "v${VERSION}"
    PATCHES
        disable-warning-4996.patch
        fix-exported-config.patch
        fix-dll-builds.patch
        gcc-13-fix-backport.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_ASTYLE=OFF
        -DBUILD_DOCUMENTATION=OFF
        -DBUILD_GEOSOP=OFF
        -DBUILD_TESTING=OFF
        -DBUILD_BENCHMARKS=OFF
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/GEOS)
vcpkg_fixup_pkgconfig()

if(NOT VCPKG_TARGET_IS_WINDOWS OR VCPKG_TARGET_IS_MINGW)
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")
    file(RENAME "${CURRENT_PACKAGES_DIR}/bin/geos-config" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/geos-config")
    file(CHMOD "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/geos-config" FILE_PERMISSIONS
        OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE
    )
    if(NOT VCPKG_BUILD_TYPE)
        file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin")
        file(RENAME "${CURRENT_PACKAGES_DIR}/debug/bin/geos-config" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/geos-config")
        file(CHMOD "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/geos-config" FILE_PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_EXECUTE
            WORLD_READ WORLD_EXECUTE
        )
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static" OR NOT VCPKG_TARGET_IS_WINDOWS)
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

vcpkg_copy_pdbs()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
