{% set __echo_env = salt['pillar.get']('echo_env') %}
EchoPillarEnv:
  cmd.run:
    - name: echo env {{saltenv}}
    - context:
        payload: {{ __echo_env }}