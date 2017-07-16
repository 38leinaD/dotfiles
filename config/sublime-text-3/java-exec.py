import sublime
import sublime_plugin
import subprocess
import os

class JavaExecCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		view = self.view
		file = view.window().active_view().file_name()
		filename = os.path.basename(file)
		classname = os.path.splitext(filename)[0]
		dirname = os.path.dirname(file)
		view.run_command('save')
		result = subprocess.check_output('cd %s && javac %s && java %s' % (dirname, filename, classname), stderr=subprocess.STDOUT, shell=True)
		html_result = "<br />".join(result.decode("utf-8").split("\n"))
		view.show_popup(html_result, location=-1, max_width=600)
