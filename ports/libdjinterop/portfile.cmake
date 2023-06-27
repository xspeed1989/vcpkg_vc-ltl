vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xsco/libdjinterop
    REF ${VERSION}
    SHA512 7becb83ab62412b3d437ddee23b248a697b162f6b8a64070cd8a9782a4fce7726baaf12ea193b8e21bcf561a00039ab1ae1f04d00e6cbe8344ec19751779db14
    HEAD_REF master
)

vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/DjInterop)
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
