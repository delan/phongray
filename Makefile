path = $(HOME)/phongray
name = hello
user = 17065012
server = ark.cs.curtin.edu.au
frames = 600
rough_width = 320
rough_height = 180
final_width = 4096
final_height = 2304
video_width = 3840
video_height = 2160
video_fps = 60

help:
	# phongray: a disgusting hack of a distributed POV-Ray renderer
	# usage: make [option=value ...] [command]
	#
	# global options:
	#   * path: the path to phongray relative to $$HOME [phongray]
	#   * name: the name of your project, without any suffix [hello]
	#   * user: your remote user name [17065012]
	#   * server: the central server to start from [ark.cs.curtin.edu.au]
	#   * frames: the total number of frames in the INI file [120]
	#   * rough_width: the width of the rough render [320]
	#   * rough_height: the height of the rough render [180]
	#   * final_width: the width of the final render [4096]
	#   * final_height: the height of the final render [2304]
	#   * video_width: the width of the video [3840]
	#   * video_height: the height of the video [2160]
	#
	# commands:
	#   * setup: generate and upload an SSH key pair
	#   * live: rough render and play locally, requires X11
	#   * local: final render locally
	#   * remote: final render remotely, run from ark
	#   * video: make video from rendered images
	#   * nodes.tsv: probe 134.7.44.0/22 for working Linux hosts
	#   * clean: delete all generated files except nodes.tsv and SSH keys
	#   * superclean: delete all generated files with no exceptions

video:
	ffmpeg \
		-r '$(video_fps)' \
		-pattern_type glob \
		-i 'png/$(name)-*.png' \
		-vcodec h264 \
		-s '$(video_width)x$(video_height)' \
		-r '$(video_fps)' \
		-movflags faststart \
		-bf 2 \
		-pix_fmt yuv420p \
		mp4/video.mp4

setup:
	ssh-keygen -t rsa -C phongray -N '' -f ssh/phongkey
	echo 'phongray: setup: creating directories on ark'
	ssh -o 'StrictHostKeyChecking no' $(user)@$(server) \
		'mkdir -p .ssh'
	echo 'phongray: setup: copying SSH key files'
	ssh -o 'StrictHostKeyChecking no' $(user)@$(server) \
		'cat >> .ssh/authorized_keys' < ssh/phongkey.pub

config:
	cat default.ini | \
		sed "s/{NAME}/$(config_name)/" | \
		sed "s/{WIDTH}/$(config_width)/" | \
		sed "s/{HEIGHT}/$(config_height)/" | \
		sed "s/{AA}/$(config_aa)/" | \
		sed "s/{DISPLAY}/$(config_display)/" | \
		sed "s/{OUTPUT}/$(config_output)/" | \
		sed "s/{START}/$(config_start)/" | \
		sed "s/{END}/$(config_end)/" | \
		sed "s/{INDEX}/$(config_index)/" \
		>> ini/$(config_name)-$(config_index).ini

live:
	cp "src/$(name).pov" "pov/$(name)-0.pov"
	cp "src/$(name).ini" "ini/$(name)-0.ini"
	$(MAKE) \
		config_name="$(name)" \
		config_width="$(rough_width)" \
		config_height="$(rough_height)"\
		config_aa=Off \
		config_display=On \
		config_output=Off \
		config_start=1 \
		config_end="$(frames)" \
		config_index=0 \
		config
	(cd png && povray "../ini/$(name)-0.ini" > "../log/$(name)-0.log" 2>&1)

local:
	cp "src/$(name).pov" "pov/$(name)-0.pov"
	cp "src/$(name).ini" "ini/$(name)-0.ini"
	$(MAKE) \
		config_name="$(name)" \
		config_width="$(final_width)" \
		config_height="$(final_height)"\
		config_aa=On \
		config_display=Off \
		config_output=On \
		config_start=1 \
		config_end="$(frames)" \
		config_index=0 \
		config
	(cd png && povray "../ini/$(name)-0.ini" > "../log/$(name)-0.log" 2>&1)

remote: nodes.tsv
	for index in $$(seq 1 $$(wc -l < nodes.tsv)); do \
		cp "src/$(name).pov" "pov/$(name)-$$index.pov"; \
		cp "src/$(name).ini" "ini/$(name)-$$index.ini"; \
		$(MAKE) \
			config_name="$(name)" \
			config_width="$(final_width)" \
			config_height="$(final_height)"\
			config_aa=On \
			config_display=Off \
			config_output=On \
			config_start="$$( \
				echo "($$index - 1) *" \
					"$(frames) /" \
					"$$(wc -l < nodes.tsv) + 1" \
					| bc \
			)" \
			config_end="$$( \
				echo "scale = 10;" \
					"x = $$index *" \
					"$(frames) /" \
					"$$(wc -l < nodes.tsv);" \
					"scale = 0;" \
					"if (x > x/1) print x / 1 + 1" \
					"else print x / 1" \
					| bc \
			)" \
			config_index="$$index" \
			config && \
		ssh \
			-o 'ConnectTimeout=30' \
			-o 'ConnectionAttempts=3' \
			-o 'StrictHostKeyChecking no' \
			-o 'PreferredAuthentications=publickey' \
			-i 'ssh/phongkey' \
			$$(sed $$index'q;d' nodes.tsv | cut -f 1) \
			'cd "$(path)/png"; \
			povray "../ini/$(name)-'"$$index"'.ini" \
			> "../log/$(name)-'"$$index"'.log" 2>&1' & \
	done

nodes.tsv:
	touch nodes.tsv
	for a in $$(  seq  134  134  ); do \
	for b in $$(  seq  7    7    ); do \
	for c in $$(  seq  44   47   ); do \
	for d in $$(  seq  1    254  ); do \
		printf '%s' "$$a.$$b.$$c.$$d:"; \
		ping -c 1 -W 1 -w 1 $$a.$$b.$$c.$$d > /dev/null 2>&1; \
		if [ $$? -eq 0 ]; then \
			printf '%s' ' ping'; \
			ssh \
			-o 'ConnectTimeout=1' \
			-o 'ConnectionAttempts=1' \
			-o 'StrictHostKeyChecking no' \
			-o 'PreferredAuthentications=publickey' \
			-i 'ssh/phongkey' \
			"$$a.$$b.$$c.$$d" povray > /dev/null 2>&1; \
			if [ $$? -eq 0 ]; then \
				printf '%s' ' ssh'; \
				printf '%s' "$$a.$$b.$$c.$$d" >> nodes.tsv; \
				printf '\t%s' "$$( \
				ssh \
				-o 'ConnectTimeout=1' \
				-o 'ConnectionAttempts=1' \
				-o 'StrictHostKeyChecking no' \
				-o 'PreferredAuthentications=publickey' \
				-i 'ssh/phongkey' \
				"$$a.$$b.$$c.$$d" hostname \
				)" >> nodes.tsv; \
				echo >> nodes.tsv; \
			fi; \
		else \
			printf '%s' ' down'; \
		fi; \
		echo; \
	done; done; done; done

clean:
	rm -f ini/* log/* mp4/* png/* pov/*

superclean: clean
	rm -f nodes.tsv ssh/*
