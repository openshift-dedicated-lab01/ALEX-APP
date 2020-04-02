local app = import "lib/app.libsonnet";
{
    server: app.app("server", "registry.hub.docker.com/alekssd/server:latest", "bo", "dev-21"){
      deployment+: {
        spec+: {
          template+: {
            spec+: {
              containers_+: {
                server+: {
                  env_+: {
                    foo: "bar",
                  },
                },
              },
            }
          },
        },
      },
    },
}
