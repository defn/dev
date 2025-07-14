# Proxy Configuration

This directory contains proxy server configuration files.

## Files

- `squid.conf` - Squid proxy server configuration

## Purpose

Provides caching proxy configuration for development environments. The Squid proxy server helps cache HTTP requests and responses to improve build performance and reduce network traffic.

## Usage

The proxy configuration is used by the cache infrastructure defined in the parent directory's docker-compose setup.