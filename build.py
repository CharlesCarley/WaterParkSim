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

    def create(self, relative):
        result = self.path
        if (sys.platform == "win32"):
            relative = relative.replace('/', '\\')
        else:
            relative = relative.replace('\\', '/')

        joinResult = os.path.join(result, relative)
        if (not os.path.isdir(joinResult)):
            os.makedirs(joinResult)
        return Path(joinResult)

    def subdir(self, relative):
        result = self.path
        if (sys.platform == "win32"):
            relative = relative.replace('/', '\\')
        else:
            relative = relative.replace('\\', '/')

        joinResult = os.path.join(result, relative)
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

        sourceDir = Path()
        self.opts['source'] = sourceDir
        self.opts['publish'] = sourceDir.create("docs")
        self.opts['test'] = sourceDir.join("test")

        if (sys.platform == "win32"):
            platName = "windows"
        else:
            platName = 'linux'

        self.opts['platform'] = platName

    def home(self): return self.opts['source']
    def sourceDir(self): return self.opts['source']
    def flutterPlatform(self): return self.opts['platform']
    def pubDir(self): return self.opts['publish']
    def testDir(self): return self.opts['test']

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
        self.pubDir().remove()
        self.goto(self.sourceDir())
        self.run("flutter clean")
        self.run("flutter pub get")

    def buildBase(self, kind, args):
        self.release = True
        self.goto(self.sourceDir())
        self.buildClean()
        self.buildTest()

        self.goto(self.sourceDir())
        self.run("flutter pub get")
        self.run("flutter build %s %s"%(kind, args))

        flBuild = self.sourceDir().subdir("build/%s"%kind)
        self.pubDir().remove()
        flBuild.copyTree(self.pubDir())

    def buildWeb(self):
        if self.findOpt("gh"):
            self.buildBase("web", "--release --base-href /WaterParkSim/")
        else:
            self.buildBase("web", "--release --base-href /")

    def buildWin(self):
        self.buildBase("windows", "--release")
    def buildLinux(self):
        self.buildBase("linux", "--release")

    def buildTest(self):
        self.release = True
        self.goto(self.sourceDir())
        self.run("flutter test")

    def logUsage(self):
        print("build <kind> <options>")
        print("")
        print("Where kind is one of the following")
        print("")
        print("web    - Builds the web project")
        print("win    - Builds the desktop windows project")
        print("linux  - Builds the desktop linux project")
        print("test   - Builds the test source")
        print("")
        print("")
        print("clean  - Removes the build directories")
        print("help   - Displays this message")
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
    elif (build.findOpt("test")):
        build.buildTest()
    elif (build.findOpt("clean")):
        build.buildClean()
    else:
        build.logUsage()
 
    build.goto(build.home())

if __name__ == '__main__':
    main(len(sys.argv), sys.argv)
