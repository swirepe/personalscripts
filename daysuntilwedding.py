#!/usr/bin/env python
from datetime import date, datetime

wedding = datetime(2019, 7, 15)
delta = wedding - datetime.now()
print delta.days, "days"
