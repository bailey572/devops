#!/bin/bash

# Install Jenkins Plugins
curl --output /tmp/jenkins-plugin-cli http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  ws-cleanup:0.42
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  variant:1.4
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  trilead-api:1.57.v6e90e07157e1
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  token-macro:293.v283932a_0a_b_49
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  timestamper:1.17
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  structs:318.va_f3ccb_729b_71
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  sshd:3.237.v883d165a_c1d3
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  ssh-credentials:277.v95c2fec1c047
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  ssh-slaves:1.814.vc82988f54b_10
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  snakeyaml-api:1.30.1
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  script-security:1175.v4b_d517d6db_f0
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  scm-api:608.vfa_f971c5a_a_e9
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  resource-disposer:0.19
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  popper-api:1.16.1-3
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  popper2-api:2.11.5-2
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  plugin-util-api:2.17.0
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  plain-credentials:1.8
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-support:820.vd1a_6cc65ef33
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-step-api:625.vd896b_f445a_f8
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-stage-view:2.24
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-stage-tags-metadata:2.2086.v12b_420f036e5
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-stage-step:293.v200037eefcd5
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-scm-step:400.v6b_89a_1317c9a_
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-rest-api:2.24
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-durable-task-step:1146.v1a_d2e603f929
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-multibranch:716.vc692a_e52371b_
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-model-api:2.2086.v12b_420f036e5
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-milestone-step:101.vd572fef9d926
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-job:1186.v8def1a_5f3944
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-input-step:448.v37cea_9a_10a_70
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-cps:2725.v7b_c717eb_12ce
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-github-lib:38.v445716ea_edda_
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-cps-global-lib:588.v576c103a_ff86
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-model-definition:2.2086.v12b_420f036e5
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-build-step:2.18
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-basic-steps:948.v2c72a_091b_b_68
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-api:1164.v760c223ddb_32
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pipeline-graph-analysis:195.v5812d95a_a_2f9
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  workflow-aggregator:581.v0c46fa_697ffd
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  pam-auth:1.8
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  antisamy-markup-formatter:2.7
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  jdk-tool:1.5
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  okhttp-api:4.9.3-105.vb96869f8ac3a
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  matrix-project:771.v574584b_39e60
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  matrix-auth:3.1.2
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  mailer:414.vcc4c33714601
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  lockable-resources:2.15
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  ldap:2.10
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  junit:1119.va_a_5e9068da_d7
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  jsch:0.1.55.2
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  jquery3-api:3.6.0-4
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  jnr-posix-api:3.1.7-3
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  jaxb:2.3.6-1
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  momentjs:1.1.1
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  handlebars:3.0.8
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  ace-editor:1.1
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  javax-mail-api:1.6.2-6
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  javax-activation-api:1.2.0-3
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  jjwt-api:0.11.5-77.v646c772fddb_0
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  jackson2-api:2.13.3-285.vc03c0256d517
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  gradle:1.39.1
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  github:1.34.3
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  github-branch-source:1637.vd833b_7ca_7654
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  github-api:1.303-400.v35c2d8258028
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  git-server:1.11
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  git-client:3.11.0
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  git:4.11.3
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  font-awesome-api:6.1.1-1
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  cloudbees-folder:6.729.v2b_9d1a_74d673
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  echarts-api:5.3.2-3
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  durable-task:496.va67c6f9eefa7
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  docker-plugin:1.2.9
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  docker-workflow:1.28
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  docker-commons:1.19
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  docker-java-api:3.2.13-37.vf3411c9828b9
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  credentials:1129.vef26f5df883c
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  credentials-binding:523.vd859a_4b_122e6
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  command-launcher:84.v4a_97f2027398
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  checks-api:1.7.4
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  caffeine-api:2.9.3-65.v6a_47d0f4d1fe
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  build-timeout:1.21
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  branch-api:2.1046.v0ca_37783ecc5
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  bouncycastle-api:2.26
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  bootstrap5-api:5.1.3-7
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  bootstrap4-api:4.6.0-5
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  authentication-tokens:1.4
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  apache-httpcomponents-client-4-api:4.5.13-1.0
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` install-plugin  ant:475.vf34069fef73c

# Add the Capstone5 project to jenkins
sudo systemctl restart jenkins

curl https://raw.githubusercontent.com/bailey572/devops/main/05_Capstone/JenkinsFile/config.xml --output /tmp/config.xml 
java -jar /tmp/jenkins-plugin-cli -s http://localhost:8080/ -auth admin:`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` -webSocket create-job Capstone5 < /tmp/config.xml

echo Jenkins Plugins Installed