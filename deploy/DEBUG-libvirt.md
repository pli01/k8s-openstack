# debug libvirt arm64
apt-get update
apt-get install -y qemu-efi-aarch64
apt-get install -y qemu-utils
mkdir /tmp/libvirt-test/
qemu-img create -f qcow2 /tmp/libvirt-test/test.qcow2 1G

cat <<EOF > /tmp/test.xml
<domain type='qemu'>
<name>test-aarch64</name>
<memory unit='MiB'>512</memory> <vcpu>1</vcpu>
<os>
<type arch='aarch64' machine='virt'>hvm</type>
</os>
<devices>
<emulator>/usr/bin/qemu-system-aarch64</emulator>
<disk type='file' device='disk'>
<driver name='qemu' type='qcow2'/>
<source file='/tmp/libvirt-test/test.qcow2'/>
<target dev='vda' bus='virtio'/>
</disk>
<console type='pty'/>
<serial type='pty'/>
<graphics type='vnc' autoport='yes'/>
</devices>
</domain>
EOF

virsh define /tmp/test.xml
virsh start test-aarch64

