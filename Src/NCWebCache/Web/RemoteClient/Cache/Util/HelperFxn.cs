// Copyright (c) 2018 Alachisoft
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//    http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using System;
using System.Text;
using System.Net.Sockets;

namespace Alachisoft.NCache.Web.Caching.Util
{
    internal class HelperFxn
    {
        /// <summary>
        /// Converts the byte into string using UTF8Encoding
        /// </summary>
        /// <param name="buffer">buffer containing values to be converted</param>
        /// <returns></returns>
        internal static string ToString(byte[] buffer)
        {
            return UTF8Encoding.UTF8.GetString(buffer);
        }

        internal static string ToStringUni(byte[] buffer)
        {
            return UTF8Encoding.Unicode.GetString(buffer);
        }

        internal static string ToString(byte[] buffer, int offset, int size)
        {
            return UTF8Encoding.UTF8.GetString(buffer, offset, size);
        }

        /// <summary>
        /// Converts byte array to string using UTF8Encoding
        /// </summary>
        /// <param name="data">values to be converted to byte</param>
        /// <returns></returns>
        internal static byte[] ToBytes(string data)
        {
            return UTF8Encoding.UTF8.GetBytes(data);
        }

        internal static byte[] ToBytesUni(string data)
        {
            return UTF8Encoding.Unicode.GetBytes(data);
        }

        /// <summary>
        /// Converts the specified byte array to int. 
        /// It is callers responsibility to ensure that values can be converted to Int32
        /// </summary>
        /// <param name="buffer"></param>
        /// <returns></returns>
        internal static int ToInt32(byte[] buffer)
        {
            int cInt = 0;
            try
            {
                cInt = Convert.ToInt32(UTF8Encoding.UTF8.GetString(buffer));
            }
            catch (Exception)
            {
                throw new InvalidCastException("Input endIndex is not in correct format.");
            }

            return cInt;
        }

        internal static int ToInt32(byte[] buffer, int offset, int size)
        {
            int cInt = 0;
            try
            {
                cInt = Convert.ToInt32(UTF8Encoding.UTF8.GetString(buffer, offset, size));
            }
            catch (Exception)
            {
                throw new InvalidCastException("Input endIndex is not in correct format.");
            }

            return cInt;
        }

        internal static byte[] CopyTo(byte[] copyFrom, int startIndex, int endIndex)
        {
            byte[] copyIn = new byte[endIndex - startIndex];
            int count = 0;

            for (int i = startIndex; i < endIndex; i++)
                copyIn[count++] = copyFrom[i];
            return copyIn;
        }

        internal static byte[] CopySubArray(byte[] copyFrom, int startIndex, int length)
        {
            byte[] copyIn = new byte[length];
            int count = 0;

            for (int i = startIndex; i < length + startIndex; i++)
                copyIn[count++] = copyFrom[i];
            return copyIn;
        }

        private static void AssureRecieve(Socket client, ref byte[] buffer)
        {
            int bytesRecieved = 0;
            do
            {
                bytesRecieved += client.Receive(buffer, bytesRecieved, buffer.Length - bytesRecieved, SocketFlags.None);
            } while (bytesRecieved < buffer.Length);
        }
    }
}