#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""Shield cleanup utilities."""

import re
import dateutil.parser
import docker

def remove_old_sb_images():
    """Remove all outdated Shield images except for the most recent two."""
    sb_tag_re = re.compile(r'^securebrowsing/([\w-]+):[0-9\-\.]+$')

    client = docker.from_env()

    images = set(client.images.list())

    sb_images = set()
    tag_img_dict = dict()

    for i in images:
        for tag in i.attrs.get('RepoTags'):
            match = sb_tag_re.match(tag)
            if match:
                sb_images.add(i)
                short_tag = match.group(1)
                if short_tag in tag_img_dict:
                    tag_img_dict[short_tag].add(i)
                else:
                    new_s = set()
                    new_s.add(i)
                    tag_img_dict[short_tag] = new_s

    images_to_preserve = set()

    for tag, imgs in tag_img_dict.items():
        two_latest = sorted(imgs,
                            key=lambda i: dateutil.parser.parse(i.attrs.get('Created')),
                            reverse=True)[:2]
        images_to_preserve.update(two_latest)

    images_to_remove = sb_images - images_to_preserve
    if not images_to_remove:
        print('Nothing to remove')
    else:
        for i in images_to_remove:
            print('Removing image ID={0}, tags={1}'.format(i.id, i.attrs.get('RepoTags')))
            client.images.remove(image=i.id, force=True, noprune=False)

    print('Pruning containers...')
    client.containers.prune()
    print('Pruning images...')
    client.images.prune()
    print('done')

remove_old_sb_images()
