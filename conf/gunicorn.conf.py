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
access_log_format = '%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-Agent}i"'
accesslog = "/var/log/__APP__/__APP__-access.log"
errorlog = "/var/log/__APP__/__APP__-error.log"
