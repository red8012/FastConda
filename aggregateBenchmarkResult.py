TARGETS = ['alpine', 'optimizedconda', 'official', 'revsys', 'miniconda', 'intel']
N_ROUNDS = 1

result1 = {target: [] for target in TARGETS}
result2 = {target: [] for target in TARGETS}

for target in TARGETS:
    with open(f'{target}-1.txt') as f:
        django1_time = 0.
        django2_time = 0.
        for line in f:
            if line.startswith('Avg'):
                split = line.split()
                django1_time += float(split[1])
                django2_time += float(split[3][:-1])
        result1[target].append(django1_time)
        result2[target].append(django2_time)

with open('result1.csv', 'w') as f:
    for target in TARGETS:
        f.write(f'{target},{",".join(str(i) for i in result1[target])}')
with open('result2.csv', 'w') as f:
    for target in TARGETS:
        f.write(f'{target},{",".join(str(i) for i in result2[target])}')
