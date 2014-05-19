//
//  MapReduceIndex.h
//  CBForest
//
//  Created by Jens Alfke on 5/15/14.
//  Copyright (c) 2014 Couchbase. All rights reserved.
//

#ifndef __CBForest__MapReduceIndex__
#define __CBForest__MapReduceIndex__

#include "Index.h"

namespace forestdb {

    class EmitFn {
    public:
        virtual void operator() (Collatable key, Collatable value) =0;
    };

    class MapFn {
    public:
        virtual void operator() (const Document&, EmitFn& emit) =0;
    };

    class MapReduceIndex : public Index {
    public:
        MapReduceIndex(std::string path, Database::openFlags, const Database::config&,
                       Database* sourceDatabase);

        void readState();
        
        void setup(int indexType, MapFn *map, std::string mapVersion);

        sequence lastSequenceIndexed() const    {return _lastSequenceIndexed;}
        sequence lastSequenceChangedAt() const  {return _lastSequenceChangedAt;}

        void updateIndex();

    private:
        void invalidate();
        void saveState(Transaction& t);
        
        Database* _sourceDatabase;
        MapFn* _map;
        std::string _mapVersion, _lastMapVersion;
        int _indexType;
        sequence _lastSequenceIndexed, _lastSequenceChangedAt;
    };
}

#endif /* defined(__CBForest__MapReduceIndex__) */