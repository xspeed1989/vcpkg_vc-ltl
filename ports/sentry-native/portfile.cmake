vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/getsentry/sentry-native/releases/download/${VERSION}/sentry-native.zip"
    FILENAME "sentry-native-${VERSION}.zip"
    SHA512 81b935a0b909885d842b870d05d96d46ccb85ac4f91456e07a92b85547a96ba8c3ed620bc7034823fd4639d1f3698b5c40fc1ed4a93e1c997ce757dfb7a4d529
)

vcpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    NO_REMOVE_ONE_LEVEL
    PATCHES
        fix-warningC5105.patch
        fix-config-cmake.patch
)
file(REMOVE_RECURSE "${SOURCE_PATH}/external/crashpad/third_party/zlib/zlib")

vcpkg_list(SET options)

if(NOT "backend" IN_LIST FEATURES)
    vcpkg_list(APPEND options "-DSENTRY_BACKEND=none")
elseif(DEFINED SENTRY_BACKEND)
    # Legacy, possible override from triplet, but cannot handle dependencies
    vcpkg_list(APPEND options "-DSENTRY_BACKEND=${SENTRY_BACKEND}")
endif()

if(NOT "transport" IN_LIST FEATURES)
    vcpkg_list(APPEND options "-DSENTRY_TRANSPORT=none")
endif()

if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    set(VCPKG_CXX_FLAGS "/D_CRT_DECLARE_NONSTDC_NAMES ${VCPKG_CXX_FLAGS}")
    set(VCPKG_C_FLAGS "/D_CRT_DECLARE_NONSTDC_NAMES ${VCPKG_C_FLAGS}")
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
        -DSENTRY_BUILD_TESTS=OFF
        -DSENTRY_BUILD_EXAMPLES=OFF
        -DCRASHPAD_ZLIB_SYSTEM=ON
    MAYBE_UNUSED_VARIABLES
        CRASHPAD_ZLIB_SYSTEM
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_cmake_config_fixup(PACKAGE_NAME sentry CONFIG_PATH lib/cmake/sentry)

if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/crashpad_handler${VCPKG_TARGET_EXECUTABLE_SUFFIX}")
    vcpkg_copy_tools(TOOL_NAMES crashpad_handler AUTO_CLEAN)
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
