1. Install Nodejs (https://nodejs.org/en/download/)
2. Install pm2  :
    a. Buka CMD / Terminal
    b. Ketik Perintah =>npm install pm2 -g
    c. Cek pm2 ketik perintah =>pm2 list
3. Jalankan API-BPOM :
    a. Buka CMD / Terminal
    b. Ketik perintah =>pm2 start server.js --name "API-BPOM"
4. Command PM2 :
    a. pm2 logs (untuk melihat logs error).
    b. pm2 list (melihat status / list app yang berjalan di pm2).
    c. pm2 monit (memonitoring app yang sedang berjalan)