import sys
import subprocess
import json
import texttable as tt

class ReportDataNodes:
    def __init__(self):
        self.nodes = []
        self.columns = ["NAME", 'IP', 'STATUS', 'ROLE', 'LABELS']
        self.rows = []
        self.collect_data_for_report()

    def collect_data_for_report(self):
        output = subprocess.check_output('docker node ls', shell=True).decode('ascii').strip().split('\n')
        self.nodes = [ReportDataNodes.make_dict_entry(string.strip().split()) for string in output if not 'HOSTNAME' in string]
        node_row = []
        for node in self.nodes:
            node_data = json.loads(subprocess.check_output('docker node inspect {}'.format(node['id']), shell=True))[0]
            node_name = node['name']
            if node_name == '*':
               node_name = "localhost"
            if 'Leader' in node_data['ManagerStatus']:
               node_name += '_(Leader)'
            node_row.append(node_name)
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
        print('Shield Nodes Status: ')
        print(s)

    @staticmethod
    def make_dict_entry(array):
        return {'id': array[0], 'name': array[1]}

class ReportDataServices:
    def __init__(self):
        self.nodes = []
        self.columns = []
        self.rows = []
        self.collect_data_for_report()

    def collect_data_for_report(self):
        nodecol=""
        output = subprocess.check_output('docker node ls', shell=True).decode('ascii').strip().split('\n')
        for line in output:
            fields = line.strip().split()
            
            if fields[1] == '*':
               self.nodes.append(fields[2])  
               nodecol = fields[2]+'(*)'
               nodecol += ' ' + fields[3]
            elif fields[1] == 'HOSTNAME':
               nodecol='Services'
            else:
               self.nodes.append(fields[1])  
               nodecol = fields[1]
               nodecol += ' ' + fields[2]
            self.columns.append( nodecol )
        self.columns.append( 'Total' )

        svc_row = []
        output = subprocess.check_output('docker service ls', shell=True).decode('ascii').strip().split('\n')
        for line in output:
            fields = line.strip().split()
            cur_service = fields[1]
            if( cur_service != 'NAME' and fields[3]!='0/0' ):
               svc_row.append( cur_service[7:] )
               for cur_node in self.nodes:
                  command = 'docker service ps {0} | grep -v "Shutdown" | grep -v "Pending" | grep -c {1}'.format(cur_service, cur_node) 
                  try:
                     svc_node = subprocess.check_output(command, shell=True).decode('ascii').strip()
                  except subprocess.CalledProcessError as grepexc:
                     svc_node = '0'
                  svc_row.append(svc_node)
               svc_row.append(fields[3])
               self.rows.append(svc_row)
               svc_row = []

    def print(self):
        table = tt.Texttable()
        table.header(self.columns)
        table.add_rows(self.rows, header=False)
        s = table.draw()
        print('Shield Services Status: ')
        print(s)

    @staticmethod
    def make_dict_entry(array):
        return {'id': array[0], 'name': array[1]}


def main(args):
    data = ReportDataNodes()
    data.print()
    data = ReportDataServices()
    data.print()

if __name__ == '__main__':
    main(sys.argv)
