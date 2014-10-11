# FindClangTidy.cmake
#
# This CMake script will search for clang-tidy and set the following
# variables
#
# CLANG_TIDY_FOUND : Whether or not clang-tidy is available on the target system
# CLANG_TIDY_VERSION : Version of clang-tidy
# CLANG_TIDY_EXECUTABLE : Fully qualified path to the clang-tidy executable
#
# The following variables will affect the operation of this script
# CLANG_TIDY_SEARCH_PATHS : List of directories to search for clang-tidy in,
#                           before searching any system paths. This should be
#                           the prefix to which clang-tidy was installed, and
#                           not the path that contains the clang-tidy binary.
#                           E.g. /opt/ not /opt/bin/
#
# See LICENCE.md for Copyright info

include (${CMAKE_CURRENT_LIST_DIR}/tooling-find-package-cmake-util/ToolingFindPackageUtil.cmake)

function (_find_clang_tidy)

    # Set-up the directory tree of the clang-tidy installation
    set (BIN_SUBDIR bin)
    set (CLANG_TIDY_EXECUTABLE_NAME clang-tidy)

    psq_find_tool_executable (${CLANG_TIDY_EXECUTABLE_NAME}
                              CLANG_TIDY_EXECUTABLE
                              PATHS ${CLANG_TIDY_SEARCH_PATHS}
                              PATH_SUFFIXES "${BIN_SUBDIR}")

    psq_report_not_found_if_not_quiet (ClangTidy CLANG_TIDY_EXECUTABLE
                                       "The 'clang-tidy' executable was not"
                                       "found in any search or system paths.\n.."
                                       "Please adjust CLANG_TIDY_SEARCH_PATHS"
                                       "to the installation prefix of the"
                                       "'clang-tidy'\n.. executable or install"
                                       "clang-tidy")

    if (CLANG_TIDY_EXECUTABLE)

        set (CLANG_TIDY_VERSION_HEADER
             "LLVM version ")

        psq_find_tool_extract_version (${CLANG_TIDY_EXECUTABLE}
                                       CLANG_TIDY_VERSION
                                       VERSION_ARG --version
                                       VERSION_HEADER
                                       "${CLANG_TIDY_VERSION_HEADER}"
                                       VERSION_END_TOKEN "\n")
        psq_check_and_report_tool_version (ClangTidy
                                           ${CLANG_TIDY_VERSION}
                                           FOUND_APPROPRIATE_VERSION)

        # If we found all the paths set ClangTidy_FOUND and other related
        # variables
        if (FOUND_APPROPRIATE_VERSION)

            set (ClangTidy_FOUND TRUE)
            set (CLANG_TIDY_FOUND TRUE PARENT_SCOPE)
            set (CLANG_TIDY_EXECUTABLE ${CLANG_TIDY_EXECUTABLE} PARENT_SCOPE)
            set (CLANG_TIDY_VERSION ${CLANG_TIDY_VERSION} PARENT_SCOPE)

            psq_print_if_not_quiet (ClangTidy "ClangTidy version"
                                              "${CLANG_TIDY_VERSION} found at"
                                              "${CLANG_TIDY_EXECUTABLE}")

        else (FOUND_APPROPRIATE_VERSION)

            set (ClangTidy_FOUND FALSE)

        endif (FOUND_APPROPRIATE_VERSION)

    endif (CLANG_TIDY_EXECUTABLE)

    set (ClangTidy_FOUND ${ClangTidy_FOUND} PARENT_SCOPE)

    if (NOT ClangTidy_FOUND)

        psq_report_tool_not_found (ClangTidy "ClangTidy was not found")

    endif (NOT ClangTidy_FOUND)

endfunction (_find_clang_tidy)

_find_clang_tidy ()