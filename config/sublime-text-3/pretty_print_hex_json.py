import sublime
import sublime_plugin
import json
import codecs
import binascii

class PrettyPrintHexJsonCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        for region in self.view.sel():
            if region.empty():
                continue

            pg_hex = self.view.substr(region).strip()

            try:
                # Remove leading \x or \\x
                if pg_hex.startswith("\\x"):
                    pg_hex = pg_hex[2:]
                elif pg_hex.startswith("\\\\x"):
                    pg_hex = pg_hex[3:]

                # Convert hex to bytes
                raw_bytes = binascii.unhexlify(pg_hex)
                decoded = raw_bytes.decode("utf-8")

                # Parse JSON and pretty-print
                parsed_json = json.loads(decoded)
                pretty = json.dumps(parsed_json, indent=2)

                self.view.replace(edit, region, pretty)
            except Exception as e:
                sublime.error_message(f"Pretty Print Hex JSON failed:\n{e}")