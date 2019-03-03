import sublime
import sublime_plugin
#import lxml.etree as etree
import xml.dom.minidom
import traceback


class CommTraceFormatCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        ##allcontent = sublime.Region(0, self.view.size())
        view = self.view
        line_obj = view.line(view.sel()[0])
        line = view.substr(line_obj)
        print(view.line(view.sel()[0]))
        tokens = line.split('|')
        offset = 0
        for i in range(0, 7):
            offset += len(tokens[i]) + 1
        region = sublime.Region(line_obj.begin(), line_obj.begin() + offset)
        token_to_format = tokens[8][0 : len(tokens[8]) - 1]
        #print(token_to_format)
        xml_node = xml.dom.minidom.parseString(token_to_format)
        pretty_xml_as_string = xml_node.toprettyxml()
        sublime.status_message('Prefixr succeully %s' % ('1'))
        #view.show_popup('hello world', location=-1, max_width=600)
        #edit = self.view.begin_edit('prefixr')
        self.view.replace(edit, region, pretty_xml_as_string)
        #self.view.end_edit(edit)
        #self.view.insert(edit, 0, "Hello, World!")
