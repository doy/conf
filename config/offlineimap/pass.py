from subprocess import Popen, PIPE

def get_password(name, user):
    (out, err) = Popen(["rbw", "get", name, user], stdout=PIPE).communicate()
    return out.strip()
