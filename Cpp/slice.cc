//
//  slice.cc
//  CBForest
//
//  Created by Jens Alfke on 5/12/14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#include "slice.h"
#include <algorithm>
#include <stdlib.h>
#include <string.h>

namespace forestdb {

    int slice::compare(slice b) const {
        size_t minSize = std::min(this->size, b.size);
        int result = memcmp(this->buf, b.buf, minSize);
        if (result == 0) {
            if (this->size < b.size)
                result = -1;
            else if (this->size > b.size)
                result = 1;
        }
        return result;
    }

    slice slice::read(size_t nBytes) {
        if (nBytes > size)
            return null;
        slice result(buf, nBytes);
        moveStart(nBytes);
        return result;
    }

    bool slice::readInto(slice dst) {
        if (dst.size > size)
            return false;
        ::memcpy((void*)dst.buf, buf, dst.size);
        moveStart(dst.size);
        return true;
    }


    slice slice::copy() const {
        if (size == 0 || buf == NULL)
            return *this;
        void* copied = ::malloc(size);
        ::memcpy(copied, buf, size);
        return slice(copied, size);
    }

    void slice::free() {
        ::free((void*)buf);
        buf = NULL;
        size = 0;
    }

    slice::operator std::string() const {
        return std::string((const char*)buf, size);
    }

    const slice slice::null;

    void* alloc_slice::alloc(const void* src, size_t s) {
        void* buf = ::malloc(s);
        ::memcpy((void*)buf, src, s);
        return buf;
    }

}