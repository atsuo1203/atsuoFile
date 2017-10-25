import subprocess
import re

# zsh_historyの: 0123456789:0;hogehoge という奴をソートするつ

contents = subprocess.check_output('cat .zsh_history', shell=True)
data_list_b = contents.splitlines()
s = r': [0-9]{10}:[0-9];'
data_list = [repr(l).lstrip('b').strip('\'') for l in data_list_b]

result_set = set([re.sub(s, '', d) for d in data_list])
f = open('.zsh_history', 'w')
for r in list(result_set):
    if r != '':
        p = re.compile(r'\\+')
        r = p.sub(r'\\', r)
        if r[0] == '\"':
            r = r.strip('\"')
        f.write(r+'\n')
f.close()


