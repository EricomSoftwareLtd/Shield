import sys
import subprocess
import json
import texttable as tt
import os


class ReportData:
    def __init__(self):
        self.nodes = []
        self.columns = ["ID", "NAME", 'IP', 'STATUS', 'ROLE', 'LABELS']
        self.rows = []
        self.collect_data_for_report()

    def collect_data_for_report(self):
        output = subprocess.check_output('docker node ls', shell=True).decode('ascii').strip().split('\n')
        self.nodes = [ReportData.make_dict_entry(string.strip().split()) for string in output if not '*' in string and not 'HOSTNAME' in string]
        node_row = []
        for node in self.nodes:
            node_data = json.loads(subprocess.check_output('docker node inspect {}'.format(node['id']), shell=True))[0]
            if node_data['Status']['Addr'] in os.environ['MACHINE_IPS']:
                node_row.append(node['id'])
                node_row.append(node['name'])
                node_row.append(node_data['Status']['Addr'])
                node_row.append(node_data['Spec']['Availability'])
                node_row.append(node_data['Spec']['Role'])
                node_row.append('\n'.join([ key + '=' + value for key, value in node_data['Spec']['Labels'].items()]))
            self.rows.append(node_row)
            node_row = []

    def print(self):
        table = tt.Texttable()
        table.header(self.columns)
        table.add_rows(self.rows, header=False)
        s = table.draw()
        print('Operation Result: ')
        print(s)

    @staticmethod
    def make_dict_entry(array):
        return {'id': array[0], 'name': array[1]}

def main(args):
    data = ReportData()
    data.print()

if __name__ == '__main__':
    main(sys.argv)