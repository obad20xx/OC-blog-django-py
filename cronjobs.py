from __future__ import print_function

import schedule
import time
import os
import glob

def run_jobs(period):
    """Run all executable scripts found in .s2i/jobs/<period>/"""
    jobs_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        '.s2i', 'jobs', period
    )
    if not os.path.isdir(jobs_dir):
        return
    for script in sorted(glob.glob(os.path.join(jobs_dir, '*'))):
        if os.access(script, os.X_OK):
            print('Running job: %s' % script)
            os.system('bash %s' % script)

def hourly():
    run_jobs('hourly')

schedule.every().hour.do(hourly)

while True:
    schedule.run_pending()
    time.sleep(1)
