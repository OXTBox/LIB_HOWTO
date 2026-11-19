"""steps.py - write a topic's step files from a list of whole scripts (used by Claude while
building topics; the step files are the source of truth, this only saves typing)."""
import os
TOPICS = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'topics')


def topic(folder, num, name, needs, steps):
    d = os.path.join(TOPICS, folder)
    os.makedirs(d, exist_ok=True)
    for i, (title, adding, body) in enumerate(steps, 1):
        hdr = '-- HOWTO %s %s, step %d: %s\n-- Adding: %s\n' % (num, name, i, title, adding)
        if needs:
            hdr += '-- Needs %s.\n' % needs
        with open(os.path.join(d, 'step_%d.livecodescript' % i), 'w') as f:
            f.write(hdr + '\n' + body.strip('\n') + '\n')
