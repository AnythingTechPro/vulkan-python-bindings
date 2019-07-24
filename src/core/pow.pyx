# Copyright (c) 2019, The Vulkan Developers.
#
# This file is part of Vulkan.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# You should have received a copy of the MIT License
# along with Vulkan. If not, see <https://opensource.org/licenses/MIT>.

from libc.stdint cimport *

cdef extern from "core/pow.h":
    void free_pow_limit_bn()
    int check_proof_of_work(const uint8_t *hash, uint32_t bits)

cdef class ProofOfWork(object):

    cpdef bint check_proof_of_work(self, bytes hash, uint64_t bits):
        cdef const char* raw_hash = PyBytes_AsString(hash)
        return check_proof_of_work(<const uint8_t*>raw_hash, bits)

    def __del__(self):
        # free the proof of work limit bignum allocated when calling
        # "check_proof_of_work" which prevents us from having to reallocate
        # the pow limit bignum each time...
        free_pow_limit_bn()
