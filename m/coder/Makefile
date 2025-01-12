install:
	sudo cp coder-socat.service /etc/systemd/system/coder-socat.service
	sudo cp coder.service /etc/systemd/system/coder.service
	sudo systemctl daemon-reload
	sudo systemctl enable coder.service
	sudo systemctl start coder.service
	sudo systemctl enable coder-socat.service
	sudo systemctl start coder-socat.service