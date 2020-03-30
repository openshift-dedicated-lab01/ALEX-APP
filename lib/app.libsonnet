local kube = import "lib/kube.libsonnet";

{
  app(name, image, zone, env, replicas=1): {
    assert std.isString(name): "Name should be a string",
    assert std.isString(image): "Image should be a string",
    assert std.isString(zone): "Zone should be a string",
    assert std.isString(env): "Env should be a string",

    local my_app = self,
    deployment: kube.Deployment(name) {
      metadata+: {
          labels+: {
              zone: zone,
              env: env,
          },
      },
      spec+: {
        replicas: replicas,
        revisionHistoryLimit: "0",
        template+: {
          spec+: {
            containers_+: {
              podinfo: kube.Container("podinfo") {
                image: image,
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