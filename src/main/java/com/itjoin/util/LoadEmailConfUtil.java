//  ==================================================================
//  文件名:ConfigUtils 
//  简要功能描述:
//
//  Created by walle on 2012-11-14.
//  Copyright (c) 2011-2012年 深圳房多多科技有限公司. All rights reserved.
//  ==================================================================
package com.itjoin.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * 读取ca-server.perproties配置文件
 * 
 * @author  walle
 * @version  [版本号, 2012-11-14]
 * @see  [相关类/方法]
 * @since  [产品/模块版本]
 */
public class LoadEmailConfUtil
{
    private static Logger logger = LoggerFactory.getLogger(LoadEmailConfUtil.class);
    
    private static volatile Properties PROPERTIES;
    
    public static Properties getProperties()
    {
        if (PROPERTIES == null)
        {
            synchronized (LoadEmailConfUtil.class)
            {
                if (PROPERTIES == null)
                {
                    PROPERTIES = LoadEmailConfUtil.loadProperties("mail.properties", false, true);
                }
            }
        }
        
        return PROPERTIES;
    }
    
    public static String getProperty(String key)
    {
        return getProperties().getProperty(key, null);
    }
    
    public static String getProperty(String key, String defaultValue)
    {
        return getProperties().getProperty(key, defaultValue);
    }
    
    /**
     * Load properties file to {@link Properties} from class path.
     * 
     * @param fileName properties file name. for example: <code>dubbo.properties</code>, <code>METE-INF/conf/foo.properties</code>
     * @param allowMultiFile if <code>false</code>, throw {@link IllegalStateException} when found multi file on the class path. 
     * @return loaded {@link Properties} content. <ul>
     * <li>return empty Properties if no file found.
     * <li>merge multi properties file if found multi file
     * </ul>
     * @throws IllegalStateException not allow multi-file, but multi-file exsit on class path.
     */
    public static Properties loadProperties(String fileName, boolean allowMultiFile, boolean allowEmptyFile)
    {
        Properties properties = new Properties();
        if (fileName.startsWith("/"))
        {
            try
            {
                FileInputStream input = new FileInputStream(fileName);
                try
                {
                    properties.load(input);
                }
                finally
                {
                    input.close();
                }
            }
            catch (Throwable e)
            {
                logger.warn("Failed to load " + fileName + " file from " + fileName + "(ingore this file): "
                    + e.getMessage(),
                    e);
            }
            return properties;
        }
        
        List<java.net.URL> list = new ArrayList<java.net.URL>();
        try
        {
            Enumeration<java.net.URL> urls = LoadEmailConfUtil.class.getClassLoader().getResources(fileName);
            list = new ArrayList<java.net.URL>();
            while (urls.hasMoreElements())
            {
                list.add(urls.nextElement());
            }
        }
        catch (Throwable t)
        {
            logger.warn("Fail to load " + fileName + " file: " + t.getMessage(), t);
        }
        
        if (list.size() == 0)
        {
            if (allowEmptyFile)
            {
                logger.warn("No " + fileName + " found on the class path.");
            }
            return properties;
        }
        
        if (!allowMultiFile)
        {
            if (list.size() > 1)
            {
                String errMsg =
                    String.format("only 1 %s file is expected, but %d dubbo.properties files found on class path: %s",
                        fileName,
                        list.size(),
                        list.toString());
                logger.warn(errMsg);
                // throw new IllegalStateException(errMsg); // see http://code.alibabatech.com/jira/browse/DUBBO-133
            }
            try
            {
                properties.load(LoadEmailConfUtil.class.getClassLoader().getResourceAsStream(fileName));
            }
            catch (Throwable e)
            {
                logger.warn("Failed to load " + fileName + " file from " + fileName + "(ingore this file): "
                    + e.getMessage(),
                    e);
            }
            return properties;
        }
        
        logger.info("load " + fileName + " properties file from " + list);
        
        for (java.net.URL url : list)
        {
            try
            {
                Properties p = new Properties();
                InputStream input = url.openStream();
                if (input != null)
                {
                    try
                    {
                        p.load(input);
                        properties.putAll(p);
                    }
                    finally
                    {
                        try
                        {
                            input.close();
                        }
                        catch (Throwable t)
                        {
                        }
                    }
                }
            }
            catch (Throwable e)
            {
                logger.warn("Fail to load " + fileName + " file from " + url + "(ingore this file): " + e.getMessage(),
                    e);
            }
        }
        
        return properties;
    }
}
