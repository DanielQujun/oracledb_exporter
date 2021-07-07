GO111MODULE=off CGO_ENABLED=0 GOOS=windows GOARCH=386 ~/jfs/go/bin/go1.11 build -o oracledb-exporter-x86.exe
GO111MODULE=off CGO_ENABLED=0 GOOS=windows GOARCH=amd64 ~/jfs/go/bin/go1.11 build -o oracledb-exporter-x64.exe
