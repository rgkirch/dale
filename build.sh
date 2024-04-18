cd ~/dale2 && git fetch origin-delta && git diff master...origin-delta/master
cd ~/dale2 && git merge origin-delta/master
rm ~/dale2-build/CMakeCache.txt
cd ~/dale2 && cmd //c build.cmd
cd ~/dale2 && git add . && git commit -m "done" && git push origin-delta
echo "done."
