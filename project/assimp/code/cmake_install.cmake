# Install script for directory: /home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so.5.0.1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so.5"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/bin/libassimp.so.5.0.1"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/bin/libassimp.so.5"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so.5.0.1"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so.5"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/bin/libassimp.so")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libassimp.so")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xassimp-devx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/assimp" TYPE FILE FILES
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/anim.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/aabb.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/ai_assert.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/camera.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/color4.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/color4.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/config.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/ColladaMetaData.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/commonMetaData.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/defs.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Defines.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/cfileio.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/light.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/material.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/material.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/matrix3x3.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/matrix3x3.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/matrix4x4.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/matrix4x4.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/mesh.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/pbrmaterial.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/postprocess.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/quaternion.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/quaternion.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/scene.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/metadata.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/texture.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/types.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/vector2.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/vector2.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/vector3.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/vector3.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/version.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/cimport.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/importerdesc.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Importer.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/DefaultLogger.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/ProgressHandler.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/IOStream.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/IOSystem.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Logger.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/LogStream.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/NullLogger.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/cexport.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Exporter.hpp"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/DefaultIOStream.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/DefaultIOSystem.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/ZipArchiveIOSystem.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/SceneCombiner.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/fast_atof.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/qnan.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/BaseImporter.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Hash.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/MemoryIOWrapper.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/ParsingUtils.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/StreamReader.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/StreamWriter.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/StringComparison.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/StringUtils.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/SGSpatialSort.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/GenericProperty.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/SpatialSort.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/SkeletonMeshBuilder.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/SmallVector.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/SmoothingGroups.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/SmoothingGroups.inl"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/StandardShapes.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/RemoveComments.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Subdivision.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Vertex.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/LineSplitter.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/TinyFormatter.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Profiler.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/LogAux.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Bitmap.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/XMLTools.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/IOStreamBuffer.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/CreateAnimMesh.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/irrXMLWrapper.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/BlobIOSystem.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/MathFunctions.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Exceptional.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/ByteSwapper.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xassimp-devx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/assimp/Compiler" TYPE FILE FILES
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Compiler/pushpack1.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Compiler/poppack1.h"
    "/home/dlannan/dev/saldo/chrome-3d-tool/project/assimp/code/../include/assimp/Compiler/pstdint.h"
    )
endif()

