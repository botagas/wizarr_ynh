import multiprocessing

bind = "127.0.0.1:__PORT__"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
max_requests = 1000
max_requests_jitter = 50
preload_app = True
timeout = 30
keepalive = 2
# Use a simpler access log format to avoid Python formatting conflicts
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'
# Use the same log file as systemd for consistency
accesslog = "/var/log/__APP__/__APP__.log"
errorlog = "/var/log/__APP__/__APP__.log"
