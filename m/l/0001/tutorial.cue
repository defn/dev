package l

// 1

tutorial: #TutorialContent & {
	title:  "Expand LVM Volumes"
	iframe: "https://5000--main--pc--admin.local.defn.run/check"
	steps: [{
		title: "Run the tutorial with Tilt"
		desc:  "<b>j up</b>"
	}, {
		title: "Find the LVM volume of the file-system you are expanding"
		desc: """
			<pre><code language="class-shell">
			df -klh | grep /dev/mapper
			
			/dev/mapper/ubuntu--vg-ubuntu--lv  886G  311G  538G  37% /
			</code></pre>
			"""
	}, {
		title: "Extend the LVM volume by 100Gb"
		desc: """
			<pre><code language="class-shell">
			sudo lvextend -L +1G /dev/mapper/ubuntu--vg-ubuntu--lv

			Size of logical volume ubuntu-vg/ubuntu-lv changed from 900.00 GiB (230400 extents) to 901.00 GiB (230656 extents).
			Logical volume ubuntu-vg/ubuntu-lv successfully resized.
			</code></pre>
			"""
	}, {
		title: "Extend the file-system to match the LVM volume"
		desc: """
			<pre><code language="class-shell">
			sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
			
			resize2fs 1.47.0 (5-Feb-2023)
			Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
			old_desc_blocks = 113, new_desc_blocks = 113
			The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 236191744 (4k) blocks long.
			</code></pre>
			"""
	}]
}
