local lq = import "lib/lq.libsonnet";
{
  'server': lq.default_app {
    'name': 'server',
    'image': 'test',
    'no_values_args': [
      '--test',
      '--test2',
    ],
    'args': {
      'test': '1234',
      'args2': 'www',
      'args3': 'www',
    },
    'env': {
      'foo': 'bar',
    },
    'volumeMounts': {
      "test-data": {
        "mountPath": "/etc/test/data",
      },
    },
    'emptyDirs': ["test1","test2"],
    'volumes': {
      "test-data": {
        "persistentVolumeClaim": {"claimName": "test-data",},
      },
    },
    'pvcs': [
      {"name": "test-data", "storage": "2Gi", "accessModes": ["ReadWriteOnce","ReadWriteMany"]},
      {"name": "test-data2", "storage": "2Gi", "accessModes": ["ReadWriteMany"]},
    ],
  }, 
}
