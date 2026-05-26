#!/bin/bash

rsync --rsync-path="sudo rsync" --checksum --compress --archive --verbose masonm.org:/var/www .
