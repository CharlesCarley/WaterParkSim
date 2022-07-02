# -----------------------------------------------------------------------------
#
#   Copyright (c) Charles Carley.
#
#   This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
#   Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
# ------------------------------------------------------------------------------
import sys
import os
import subprocess
import shutil

class Path:

    def __init__(self, directory=None):
        if (directory != None):
            self.path = directory
            self.normalize()
        else:
            self.path = os.getcwd()
            self.normalize()

        if (not self.check()):
            msg = "The supplied path %s is invalid" % self.path
            raise Exception(msg)

    def normalize(self):
        if (sys.platform == "win32"):
            self.path = self.path.replace('/', '\\')
        else:
            self.path = self.path.replace('\\', '/')
        self.path = os.path.abspath(self.path)

    def check(self):
        return os.path.exists(self.path)

    def __repr__(self) -> str:
        return self.path

    def back(self, n=1):

        back = self.path
        for i in range(n):
            back = os.path.join(back, "../")

        return Path(back)

    def join(self, directory):
        result = self.path
        return Path(os.path.join(result, directory))

    def file(self, path):
        result = self.path
        return os.path.join(result, path)

    def create(self, relitave):
        result = self.path
        if (sys.platform == "win32"):
            relitave = relitave.replace('/', '\\')
        else:
            relitave = relitave.replace('\\', '/')

        joinResult = os.path.join(result, relitave)
        if (not os.path.isdir(joinResult)):
            os.makedirs(joinResult)
        return Path(joinResult)

    def subdir(self, relitave):
        result = self.path
        if (sys.platform == "win32"):
            relitave = relitave.replace('/', '\\')
        else:
            relitave = relitave.replace('\\', '/')

        joinResult = os.path.join(result, relitave)
        if (not os.path.isdir(joinResult)):
            msg = "The path '%s' does not exist " % joinResult
            raise Exception(msg)

        return Path(joinResult)

    def recreate(self):
        result = self.path

        os.makedirs(result)
        return Path(result)

    def remove(self):
        if (os.path.isdir(self.path)):
            print("Removing".ljust(20), "=> ", self.path)
            shutil.rmtree(self.path, ignore_errors=True)

    def copyTo(self, file, toPath):
        print("Copy", self.file(file), "=> ", toPath.file(file))

        shutil.copyfile(self.file(file), toPath.file(file))
        shutil.copymode(self.file(file), toPath.file(file))

    def copyTree(self, toPath):
        print("Copy".ljust(20), "=> ", toPath.path)
        shutil.copytree(self.path, toPath.path, dirs_exist_ok=True)

    def removeFile(self, file):
        localFile = os.path.join(self.path, file)

        if (os.path.isfile(localFile)):
            print("Removing", localFile)
            os.remove(localFile)


class Builder:

    def __init__(self, argc, argv):

        self.argc = argc
        self.argv = argv
        self.release = self.findOpt("--release")
        self.opts = {}

        thisDir = Path()
        sourceDir = thisDir.back()
        self.opts['dev'] = thisDir
        self.opts['source'] = sourceDir
        self.opts['web'] = sourceDir
        self.opts['publish'] = sourceDir.create("docs")

        if (sys.platform == "win32"):
            platname = "windows"
        else:
            platname = 'linux'

        self.opts['platform'] = platname
        buildDir = thisDir.create(platname)

    def home(self): return self.opts['dev']
    def sourceDir(self): return self.opts['source']
    def webDir(self): return self.opts['web']
    def webTestDir(self): return self.opts['web_test']
    def webAssetDir(self): return self.opts['web_asset']
    def flutterPlatform(self): return self.opts['platform']
    def buildOutput(self): return self.opts['build_files']
    def buildOutputEm(self): return self.opts['em_build_files']
    def bindingFile(self): return self.opts['binding_file']
    def pubDir(self): return self.opts['publish']

    def dumpOpts(self):
        print("")
        print("Build Paths")
        for k in self.opts.keys():
            print(k.ljust(20), "=>", self.opts[k])
        print("")

    def goto(self, path):
        try:
            os.chdir(path.path)
        except:
            msg = "Failed to change working directory to %s" % path.path
            raise Exception(msg)

    def configString(self):
        config = "Debug"
        if (self.release):
            config = "Release"
        return config

    def flutterBuildMode(self):
        config = ""
        if (self.release):
            config = "--release"
        return config

    def run(self, cmd):
        print("Calling =>", cmd)
        subprocess.run(cmd, shell=True, env=os.environ)

    def findOpt(self, opt):
        for i in range(self.argc):
            if (opt == self.argv[i]):
                return True
        return False

    def buildClean(self, reCreate=False):
        print("Cleaning...".ljust(20), self.argv)

        self.goto(self.webDir())
        self.run("flutter clean")

    def buildBase(self, kind, args):
        self.release = True
        self.goto(self.webDir())
        self.run("flutter pub get")
        self.run("flutter build %s %s"%(kind, args))

        flBuild = self.webDir().subdir("build/%s"%kind)
        self.pubDir().remove()
        flBuild.copyTree(self.pubDir())

    def buildWeb(self):
        self.buildBase("web", "--release --base-href /WaterParkSim/")
    def buildWin(self):
        self.buildBase("windows", "--release")
    def buildLinux(self):
        self.buildBase("linux", "--release")

    def logUsage(self):
        print("build <kind> <options>")
        print("")
        print("Where kind is one of the following")
        print("")
        print("cpp    - Builds the c++ project")
        print("em     - Compile the project with emscripten")
        print("flp    - Publish the application")
        print("fl     - Build the flutter application")
        print("clean  - Remove the build directories for all the projects")
        print("")
        print("Where options is one or more of the following switches")
        print("")
        print("--with-sdl       - Builds the SDL runtime for the C++ standalone")
        print("--with-black-box - Bulids the chip library without any performance abastractions")
        print("--release        - Compiles everything in release mode")
        print("")
        print("")


def main(argc, argv):
    build = Builder(argc, argv)
    build.dumpOpts()

    if (build.findOpt("web")):
        build.buildWeb()
    elif (build.findOpt("win")):
        build.buildWin()
    elif (build.findOpt("linux")):
        build.buildLinux()
    elif (build.findOpt("help")):
        build.logUsage()
    else:
        build.buildWin()

    build.goto(build.home())

if __name__ == '__main__':
    main(len(sys.argv), sys.argv)
