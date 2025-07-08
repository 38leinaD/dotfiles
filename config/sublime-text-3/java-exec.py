import sublime
import sublime_plugin
import subprocess
import threading
import os

class JavaExecThread(threading.Thread):
    def __init__(self, view):
        super().__init__()
        self.view = view

    def run(self):
        def show_status(msg):
            sublime.set_timeout(lambda: self.view.set_status("java_exec", msg), 0)

        #show_status("Running Java process...")
        self.view.set_status("java-exec", "Running java...")

        try:
            view = self.view
            file = view.window().active_view().file_name()
            filename = os.path.basename(file)
            classname = os.path.splitext(filename)[0]
            dirname = os.path.dirname(file)
            view.run_command('save')

            #result = subprocess.check_output('cd %s && javac %s && java %s' % (dirname, filename, classname), stderr=subprocess.STDOUT, shell=True)
            cmd = 'cd %s && ./%s' % (dirname, filename) if os.access(file, os.X_OK) else 'cd %s && /home/daniel/.sdkman/candidates/java/24-tem/bin/java %s' % (dirname, filename)
            print(cmd)
            result = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)

            html_result = "<br />".join(result.decode("utf-8").split("\n"))
            html_result = "<div style=\"color: lightgreen;\">" + html_result + "</div>"

            view.erase_status("java-exec")
            view.show_popup(html_result, location=-1, max_width=600)
            show_status("Done")
        except subprocess.CalledProcessError as e:
            print("Java error (non-zero exit):", e.output)
            html_result = "<br />".join(e.output.decode("utf-8").split("\n"))
            html_result = "<div style=\"color: red;\">" + html_result + "</div>"
            view.show_popup(html_result, location=-1, max_width=600)
            show_status("Java Error")
        except Exception as e:
            print("Java error:", e)
            show_status("Error")
        finally:
            sublime.set_timeout(lambda: self.view.erase_status("java_exec"), 2000)

class JavaExecCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        print("JavaExecCommand started")
        JavaExecThread(self.view).start()
