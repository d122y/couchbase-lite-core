//
// C4Observer_native.cs
//
// Copyright (c) 2018 Couchbase, Inc All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

using System;
using System.Linq;
using System.Runtime.InteropServices;

using LiteCore.Util;

namespace LiteCore.Interop
{
#if LITECORE_PACKAGED
    internal
#else
    public
#endif 
    unsafe static partial class Native
    {
        [DllImport(Constants.DllName, CallingConvention = CallingConvention.Cdecl)]
        public static extern C4DatabaseObserver* c4dbobs_create(C4Database* database, C4DatabaseObserverCallback callback, void* context);

        [DllImport(Constants.DllName, CallingConvention = CallingConvention.Cdecl)]
        public static extern uint c4dbobs_getChanges(C4DatabaseObserver* observer, [Out]C4DatabaseChange[] outChanges, uint maxChanges, bool* outExternal);

        [DllImport(Constants.DllName, CallingConvention = CallingConvention.Cdecl)]
        public static extern void c4dbobs_free(C4DatabaseObserver* observer);

        public static C4DocumentObserver* c4docobs_create(C4Database* database, string docID, C4DocumentObserverCallback callback, void* context)
        {
            using(var docID_ = new C4String(docID)) {
                return NativeRaw.c4docobs_create(database, docID_.AsC4Slice(), callback, context);
            }
        }

        [DllImport(Constants.DllName, CallingConvention = CallingConvention.Cdecl)]
        public static extern void c4docobs_free(C4DocumentObserver* observer);


    }
    
#if LITECORE_PACKAGED
    internal
#else
    public
#endif 
    unsafe static partial class NativeRaw
    {
        [DllImport(Constants.DllName, CallingConvention = CallingConvention.Cdecl)]
        public static extern C4DocumentObserver* c4docobs_create(C4Database* database, C4Slice docID, C4DocumentObserverCallback callback, void* context);


    }
}
