{%- from "openvpn/map.jinja" import map with context %}

# Install openvpn packages
openvpn_pkgs:
{%- if salt['pillar.get']('openvpn:use_latest', False) %}
  pkg.latest:
{% else %}
  pkg.installed:
{% endif %}
    - pkgs:
      {%- for pkg in map.pkgs %}
      - {{ pkg }}
      {%- endfor %}
{% if salt['grains.get']('os_family') == 'Windows' %}
    - require:
      - win_pki: openvpn_publisher_cert

openvpn_publisher_cert:
  win_pki.import_cert:
    - name: salt://openvpn/files/openvpn-1.cer
    - store: TrustedPublisher
{% endif %}

{%- if salt['pillar.get']('openvpn:easyrsa_pkg', False) %}
easyrsa_pkg:
  cmd.run:
    - name: |
        wget https://github.com/OpenVPN/easy-rsa/releases/download/{{map.easyrsa_pkg}}/EasyRSA-unix-{{map.easyrsa_pkg}}.tgz -O easyrsa.tgz
        mkdir -p easyrsa
        tar -xvf easyrsa.tgz -C easyrsa --strip 1
{% endif %}
