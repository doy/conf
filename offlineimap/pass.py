from subprocess import Popen, PIPE

def get_password(key):
    (out, err) = Popen(["pass", key], stdout=PIPE).communicate()
    return out.strip()
