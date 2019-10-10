#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import (division, absolute_import, print_function)

from aiohttp import web
import psutil


def checkIfProcessRunning(processName):
    '''
    Check if there is any running process that contains
    the given name processName.
    '''
    # Iterate over the all the running process
    for proc in psutil.process_iter():
        try:
            # Check if process name contains the given name string.
            if processName.lower() in proc.name().lower():
                return True
        except (psutil.NoSuchProcess, psutil.AccessDenied,
                psutil.ZombieProcess):
            pass
    return False


async def livenessProbe(request):
    process = checkIfProcessRunning('launchdd')
    if not process:
        raise web.HTTPInternalServerError()
    return web.Response(text="i'm alive!")


def main():
    app = web.Application()
    app.add_routes([web.get("/healthz", livenessProbe)])

    # disable SIGTERM handling for disruption-free rolling updates
    web.run_app(app, handle_signals=False)


if __name__ == '__main__':
    main()
