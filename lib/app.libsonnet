local kube = import "kube.libsonnet";

{
  config:: error "this file assumes a config variable",
  labels+:: {} + $.config.labels,

  app(name, image, zone, env, replicas=1): {
    assert std.isString(name): "Name should be a string",
    assert std.isString(image): "Image should be a string",
    assert std.isString(zone): "Zone should be a string",
    assert std.isString(env): "Env should be a string",

    args:: error 'Must override "args"',
    //assert std.isArray(args): "args must be an array of String",

    local my_app = self,
    serviceAccount: kube.ServiceAccount(name) {
    },
    deployment: kube.Deployment(name) {
      metadata+: {
          labels+: {
              zone: zone,
              env: env,
          },
 //         args: args,
      },
      spec+: {
        replicas: replicas,
        revisionHistoryLimit: "0",
        template+: {
          spec+: {
            serviceAccountName: name,
            containers_+: {
              [name]: kube.Container(name) {
                image: image,
                ports_+: {
                  http: { 
                    containerPort: 8443,
                  },
                  monitoring: {
                    containerPort: 8444,
                  },
                },
              },
            },
          },
        },
      },
    },
  
    service: kube.Service(name) {
      target_pod: my_app.deployment.spec.template,
    },
  },
}
