local kube = import "kube.libsonnet";

{
  default_app:: {
    no_values_args:: [],
    args:: [],
    name:: error "This file assumes a name",
    image:: error "This file assumes an image",
    env:: [],


    local my_app = self,
    serviceAccount: kube.ServiceAccount(my_app.name) {
    },
    deployment: kube.Deployment(my_app.name) {
      metadata+: {
          labels+: {
              zone: "test",
              env: "tes",
          },
      },
      spec+: {
        replicas: "1",
        revisionHistoryLimit: "0",
        template+: {
          spec+: {
            serviceAccountName: my_app.name,
            containers_+: {
              [my_app.name]: kube.Container(my_app.name) {
                image: my_app.image,
                ports_+: {
                  http: {
                    containerPort: 8443,
                  },
                  monitoring: {
                    containerPort: 8444,
                  },
                },
                args_+: my_app.args,
                args+: my_app.no_values_args,
                env_+: my_app.env,
              },
            },
          },
        },
      },
    },
    service: kube.Service(my_app.name) {
      target_pod: my_app.deployment.spec.template,
    },
  },

  vault_cfg:: {	
    deployment+: {
      spec+: {
        template+: {
          spec+: {
            
            initContainers_+: {
              "vault_init": kube.Container("vault") {
              },
            },
          },
        },
      },
    },
  },
}
