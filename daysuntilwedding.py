#!/usr/bin/env python
# -*- coding: utf-8 -*-
from datetime import date, datetime

wedding = datetime(2019, 7, 16, 0)
delta = wedding - datetime.now()
print delta.days, "days ❤️"
