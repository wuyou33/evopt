# FAQs

**Problem**:

Error using gca
While setting property 'Parent' of class ''Axes'':
Can't load '/usr/local/R2016b/bin/glnxa64/libmwosgserver.so': libXrandr.so.2: cannot open shared object file: No such file or directory

**Solution**:

```Bash
sudo yum install -y libXrandr
```
