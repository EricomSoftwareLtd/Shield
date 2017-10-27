import sys
import subprocess



class ReportData:
    def __init__(self):
        self.collect_data_for_report()

    def collect_data_for_report(self):
        pass

    def print(self):
        pass



def main():
    data = ReportData()
    data.print()


if __name__ == '__main__':
    main(sys.argv)