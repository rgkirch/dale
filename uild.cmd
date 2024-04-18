cd C:\Users\User\dale2
git pull --no-edit origin-delta master
cd C:\Users\User\dale2-build
ninja >> C:\Users\User\dale2\out.txt 2>&1
powershell -command "cp C:\Users\User\dale2\out.txt \\tsclient\C\Users\me\out.txt"
cd C:\Users\User\dale2
git add .
git commit -m "done"
git push origin-delta
