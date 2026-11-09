# Menggunakan Ubuntu Desktop berbasis Kasm yang aman untuk lingkungan non-root
FROM kasmweb/ubuntu-noble-desktop:1.16.0

# Setel port visual default agar sesuai dengan port web preview MyBinder
ENV VNC_PORT=8080
ENV DISPLAY=:1

# 1. Pindah sementara ke root HANYA untuk proses instalasi sistem
USER root

# 2. Instal Tailscale resmi di dalam container
RUN curl -fsSL https://tailscale.com/install.sh | sh

# 3. Kembali ke user biasa (UID 1000 wajib dipatuhi untuk aturan MyBinder)
USER 1000

# 4. Ekspos port 8080 untuk akses web preview
EXPOSE 8080

# 5. Jalankan Tailscale Daemon dalam mode userspace, hubungkan ke jaringan, lalu nyalakan desktop Kasm
# PENTING: Ganti 'tskey-auth-xxxxxx' dengan Auth Key asli dari dashboard Tailscale Anda.
CMD ["sh", "-c", "tailscaled --tun=userspace-networking --socks5-server=localhost:1055 & sleep 3 && tailscale up --hostname=mybinder-desktop && /dockerstartup/kasm_default_profile.sh"]
