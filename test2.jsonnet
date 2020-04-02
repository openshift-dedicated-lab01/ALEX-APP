local lq = import "lib/lq.libsonnet";
{
  'server': lq.default_app {
    'name': 'server',
    'image': 'test',
 //   'no_values_args': [
 //     '--test',
 //     '--test2',
 //   ],
    'args': {
      'test': '1234',
      'args2': 'www',
      'args3': 'www',
    },
    'env': {
      'foo': 'bar',
    },
  }, 
}
